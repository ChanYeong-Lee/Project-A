using Cinemachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterMove : MonoBehaviour
{
    [Header("Settings")]
    [SerializeField] private float moveSpeed = 2.0f;
    [SerializeField] private float sprintSpeed = 5.335f;
    [SerializeField] private float rotationSmoothTime = 0.12f;
    [SerializeField] private float speedChangeRate = 10.0f;

    [Space(10)]
    [SerializeField] private float jumpHeight = 1.2f;
    [SerializeField] private float gravity = -15.0f;

    [Space(10)]
    [SerializeField] private float jumpTimeout = 0.50f;
    [SerializeField] private float fallTimeout = 0.15f;

    [Header("Ground Check")]
    [SerializeField] private float groundOffset = -0.14f;
    [SerializeField] private float groundRadius = 0.28f;
    [SerializeField] private LayerMask groundLayers;

    [Header("Cam Settings")]
    [SerializeField] private GameObject camTarget;
    [SerializeField] private float topClamp = 70.0f;
    [SerializeField] private float bottomClamp = -30.0f;
    [SerializeField] private float cameraAngleOverride = 0.0f;
    [SerializeField] private bool lockCameraPosition = false;

    [Header("AudioClips")]
    [SerializeField] private AudioClip landingAudioClip;
    [SerializeField] private AudioClip[] footstepAudioClips;
    [SerializeField] [Range(0.0f, 1.0f)] private float footstepAudioVolume = 0.5f;

    // cinemachine
    private float camTargetYaw;
    private float camTargetPitch;

    // player
    private float speed;
    private float animationBlend;
    private float targetRotation = 0.0f;
    private float rotationVelocity;
    private float verticalVelocity;
    private float terminalVelocity = 53.0f;
    
    private bool isAim = false;
    private bool isGround = false;
    private bool isMount = false;

    // timeout deltatime
    private float jumpTimeoutDelta;
    private float fallTimeoutDelta;

    // animation IDs
    private int animIDSpeed;
    private int animIDGrounded;
    private int animIDJump;
    private int animIDFreeFall;
    private int animIDMotionSpeed;

    // components
    private Animator animator;
    private CharacterController controller;

    private const float threshold = 0.01f;
    private bool hasAnimator;

    // properties
    public Animator PAnimator => animator;
    public float Speed => speed;
    public bool IsMount => isMount;
    public bool IsAim => isAim;

    public bool LockCameraPosition { get => lockCameraPosition; set => lockCameraPosition = value; }

    private void Awake()
    {
        animator = GetComponent<Animator>();
        controller = GetComponent<CharacterController>();
    }

    private void Start()
    {
        camTargetYaw = camTarget.transform.rotation.eulerAngles.y;

        AssignAnimationIDs();

        jumpTimeoutDelta = jumpTimeout;
        fallTimeoutDelta = fallTimeout;
    }

    private void Update()
    {
        float angle = transform.eulerAngles.y - Camera.main.transform.eulerAngles.y;
        angle = Mathf.Abs(angle);
        angle = ClampAngle(angle, 0.0f, 360.0f);

        if (isMount) { return; }

        JumpAndGravity();
        GroundedCheck();
        Move();
    }

    private void LateUpdate()
    {
        CameraRotation();
    }

    public void SetMount(bool isMount)
    {
        this.isMount = isMount;
    }

    private void AssignAnimationIDs()
    {
        animIDSpeed = Animator.StringToHash("Speed");
        animIDGrounded = Animator.StringToHash("Grounded");
        animIDJump = Animator.StringToHash("Jump");
        animIDFreeFall = Animator.StringToHash("FreeFall");
        animIDMotionSpeed = Animator.StringToHash("MotionSpeed");
    }

    private void GroundedCheck()
    {
        Vector3 spherePosition = new Vector3(transform.position.x, transform.position.y - groundOffset, transform.position.z);
        isGround = Physics.CheckSphere(spherePosition, groundRadius, groundLayers, QueryTriggerInteraction.Ignore);

        animator.SetBool(animIDGrounded, isGround);
    }

    private void CameraRotation()
    {
        if (Managers.Input.look.sqrMagnitude >= threshold && !lockCameraPosition)
        {
            camTargetYaw += Managers.Input.look.x;
            camTargetPitch += Managers.Input.look.y;
        }

        camTargetYaw = ClampAngle(camTargetYaw, float.MinValue, float.MaxValue);
        camTargetPitch = ClampAngle(camTargetPitch, bottomClamp, topClamp);

        camTarget.transform.rotation = Quaternion.Euler(camTargetPitch + cameraAngleOverride, camTargetYaw, 0.0f);
    }

    private void Move()
    {
        float targetSpeed = Managers.Input.sprint ? sprintSpeed : moveSpeed;
        if (Managers.Input.move == Vector2.zero) targetSpeed = 0.0f;

        float currentHorizontalSpeed = new Vector3(controller.velocity.x, 0.0f, controller.velocity.z).magnitude;

        float speedOffset = 0.1f;

        if (currentHorizontalSpeed < targetSpeed - speedOffset ||
            currentHorizontalSpeed > targetSpeed + speedOffset)
        {
            speed = Mathf.Lerp(currentHorizontalSpeed, targetSpeed, Time.deltaTime * speedChangeRate);

            speed = Mathf.Round(speed * 1000f) / 1000f;
        }
        else
        {
            speed = targetSpeed;
        }

        animationBlend = Mathf.Lerp(animationBlend, targetSpeed, Time.deltaTime * speedChangeRate);
        if (animationBlend < 0.01f) animationBlend = 0f;

        Vector3 inputDirection = new Vector3(Managers.Input.move.x, 0.0f, Managers.Input.move.y).normalized;

        if (Managers.Input.move != Vector2.zero)
        {
            targetRotation = Mathf.Atan2(inputDirection.x, inputDirection.z) * Mathf.Rad2Deg + Camera.main.transform.eulerAngles.y;
            float rotation = Mathf.SmoothDampAngle(transform.eulerAngles.y, targetRotation, ref rotationVelocity, rotationSmoothTime);

            transform.rotation = Quaternion.Euler(0.0f, rotation, 0.0f);
        }

        Vector3 targetDirection = Quaternion.Euler(0.0f, targetRotation, 0.0f) * Vector3.forward;

        controller.Move(targetDirection.normalized * (speed * Time.deltaTime) + new Vector3(0.0f, verticalVelocity, 0.0f) * Time.deltaTime);
       
        animator.SetFloat(animIDSpeed, animationBlend);
        animator.SetFloat(animIDMotionSpeed, 1.0f);
    }

    private void JumpAndGravity()
    {
        if (isGround)
        {
            fallTimeoutDelta = fallTimeout;

            animator.SetBool(animIDJump, false);
            animator.SetBool(animIDFreeFall, false);

            if (verticalVelocity < 0.0f)
            {
                verticalVelocity = -2f;
            }

            if (Managers.Input.jump && jumpTimeoutDelta <= 0.0f)
            {
                verticalVelocity = Mathf.Sqrt(jumpHeight * -2f * gravity);
                
                animator.SetBool(animIDJump, true);
            }

            if (jumpTimeoutDelta >= 0.0f)
            {
                jumpTimeoutDelta -= Time.deltaTime;
            }
        }
        else
        {
            jumpTimeoutDelta = jumpTimeout;

            if (fallTimeoutDelta >= 0.0f)
            {
                fallTimeoutDelta -= Time.deltaTime;
            }
            else
            {
                animator.SetBool(animIDFreeFall, true);
            }

            Managers.Input.jump = false;
        }

        if (verticalVelocity < terminalVelocity)
        {
            verticalVelocity += gravity * Time.deltaTime;
        }
    }

    private float ClampAngle(float lfAngle, float lfMin, float lfMax)
    {
        if (lfAngle < -360f)
        {
            lfAngle += 360f;
        }
        
        if (lfAngle > 360f)
        {
            lfAngle -= 360f;
        }

        return Mathf.Clamp(lfAngle, lfMin, lfMax);
    }

    private void OnFootstep(AnimationEvent animationEvent)
    {
        if (animationEvent.animatorClipInfo.weight > 0.5f)
        {
            if (footstepAudioClips.Length > 0)
            {
                var index = Random.Range(0, footstepAudioClips.Length);
                AudioSource.PlayClipAtPoint(footstepAudioClips[index], transform.TransformPoint(controller.center), footstepAudioVolume);
            }
        }
    }

    private void OnLand(AnimationEvent animationEvent)
    {
        if (animationEvent.animatorClipInfo.weight > 0.5f)
        {
            AudioSource.PlayClipAtPoint(landingAudioClip, transform.TransformPoint(controller.center), footstepAudioVolume);
        }
    }
}
