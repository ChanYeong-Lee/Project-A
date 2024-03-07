using UnityEngine;
using UnityEngine.Animations.Rigging;

public class HorseMove : MonoBehaviour
{
    public enum State
    {
        Idle,
        Locomotion,
        Jump,
        Fall
    }

    public State state;
    public State lastState;

    [SerializeField] private Transform frontLeftHoe;
    [SerializeField] private Transform frontRightHoe;
    [SerializeField] private Transform frontLeftHoeTarget;
    [SerializeField] private Transform frontRightHoeTarget;
    [SerializeField] private Rig frontHoesRig;

    private Animator characterAnimator;

    private CharacterController controller;
    private HorseSlope slope;
    private Animator animator;

    private float vertical;
    private float horizontal;

    private float gravity = 15.0f;
    private float gravityVelocity = 0.0f;

    private float fallValue = 0.0f;
    private float fallVelocity = 0.0f;
    private float fallTimeout = 0.25f;
    private float fallTimeoutDelta = 0.0f;

    private float jumpTimeout = 0.8f;
    private float jumpTimeoutDelta = 0.0f;

    private float prepareJumpTimeout = 0.5f;
    private float prepareJumpTimeoutDelta = 0.0f;

    private Vector3 rootMotion = Vector3.zero;
    private Quaternion rootMotionRot = Quaternion.identity;

    
    // properties
    public float MoveSpeed => vertical;
    public State MoveState => state;

    private void Awake()
    {
        slope = GetComponent<HorseSlope>();
        animator = GetComponent<Animator>();
        controller = GetComponent<CharacterController>();
    }

    private void Update()
    {
        if (slope.IsGround)
        {
            gravityVelocity = 2.0f;
        }
        else
        {
            gravityVelocity += gravity * Time.deltaTime;
        }

        switch (state)
        {
            case State.Idle:
                IdleUpdate();
                break;
            case State.Locomotion:
                LocomotionUpdate();
                break;
            case State.Jump:
                JumpUpdate();
                break;
            case State.Fall:
                FallUpdate();
                break;
        }

        controller.Move(rootMotion);
        transform.rotation *= rootMotionRot;

        rootMotion = Vector3.zero;
        rootMotionRot = Quaternion.identity;

        animator.SetFloat("Vertical", vertical);
        animator.SetFloat("Horizontal", horizontal, 0.2f, Time.deltaTime);
        animator.SetFloat("Slope", -slope.Pitch / 40.0f);
        animator.SetInteger("State", (int)state);
        animator.SetInteger("LastState", (int)lastState);
        animator.SetFloat("Height", 1 - slope.Height * 0.5f);
        animator.SetFloat("FallValue", fallValue);

        if (characterAnimator != null)
        {
            characterAnimator.SetFloat("Vertical", vertical);
            characterAnimator.SetFloat("Horizontal", horizontal, 0.5f, Time.deltaTime);
            characterAnimator.SetFloat("Slope", -slope.Pitch / 40.0f);
            characterAnimator.SetInteger("State", (int)state);
            characterAnimator.SetInteger("LastState", (int)lastState);
            characterAnimator.SetFloat("FallValue", fallValue);
        }
    }

    public void Mount(Animator characterAnimator)
    {
        this.characterAnimator = characterAnimator;
    }

    private void IdleUpdate()
    {
        controller.Move(gravityVelocity * Vector3.down * Time.deltaTime);

        if (slope.IsGround && Managers.Input.move != Vector2.zero)
        {
            ChangeState(State.Locomotion);
        }

        if (slope.IsGround && Managers.Input.jump)
        {
            prepareJumpTimeoutDelta = prepareJumpTimeout;
            jumpTimeoutDelta = jumpTimeout;
            ChangeState(State.Jump);
        }
        else
        {
            Managers.Input.jump = false;
        }
    }

    private void LocomotionUpdate()
    {
        controller.Move(gravityVelocity * Vector3.down * Time.deltaTime);

        float forward = Mathf.Atan2(transform.forward.x, transform.forward.z) * Mathf.Rad2Deg;

        Vector3 camForward = Camera.main.transform.forward;
        camForward.y = 0;
        camForward.Normalize();

        Vector3 camRight = Camera.main.transform.right;
        camRight.y = 0;
        camRight.Normalize();

        Vector3 inputDir = Managers.Input.move.y * camForward + Managers.Input.move.x * camRight;
        inputDir.Normalize();

        float targetAngle = Mathf.Atan2(inputDir.x, inputDir.z) * Mathf.Rad2Deg;

        horizontal = (targetAngle - forward) / 90.0f * inputDir.magnitude;

        if (180.0f < Mathf.Abs(targetAngle - forward)) horizontal *= -1.0f;
        horizontal = Mathf.Clamp(horizontal, -1.0f, 1.0f);

        float targetSpeed = Managers.Input.sprint ? 4.0f : 2.0f;

        if (Managers.Input.move == Vector2.zero)
        {
            targetSpeed = 0.0f;
        }

        if (vertical <= 4.0f - 0.2f)
        {
            vertical = Mathf.Lerp(vertical, targetSpeed, Time.deltaTime);
        }

        if(4.0f - 0.2f < vertical) 
        {
            if (0.0f < inputDir.magnitude && Managers.Input.sprint)
            {
                vertical += Time.deltaTime * 0.2f * (1.0f - Mathf.Abs(horizontal) * 2.0f);
            }
            else
            {
                vertical -= Time.deltaTime * (1.0f + Mathf.Abs(horizontal));
            }
        }

        vertical = Mathf.Clamp(vertical, 0.0f, 5.0f);

        if (slope.IsGround && Managers.Input.move == Vector2.zero && vertical < 0.1f)
        {
            vertical = 0.0f;

            ChangeState(State.Idle);
        }

        if (2.0f < slope.Height)
        {
            fallTimeoutDelta -= Time.deltaTime;
            if (fallTimeoutDelta < 0.0f)
            {
                gravityVelocity = 2.0f;
                fallVelocity = vertical;
                fallValue = 0.0f;
                ChangeState(State.Fall);
            }
        }
        else
        {
            fallTimeoutDelta = fallTimeout;
        }

        if (slope.IsGround && Managers.Input.jump)
        {
            jumpTimeoutDelta = jumpTimeout;
            prepareJumpTimeoutDelta = prepareJumpTimeout;
            ChangeState(State.Jump);
        }
    }


    private void OnAnimatorMove()
    {
        rootMotionRot *= animator.deltaRotation;
        rootMotion += animator.deltaPosition;
    }
    
    private void JumpUpdate()
    {
        slope.canRotate = false;
        Managers.Input.jump = false;

        jumpTimeoutDelta -= Time.deltaTime;
        prepareJumpTimeoutDelta -= Time.deltaTime;

        if (prepareJumpTimeoutDelta + vertical * 0.1f < 0.0f && 3.0f < slope.Height)
        {
            gravityVelocity = 2.0f;
            fallVelocity = vertical;
            slope.canRotate = true;
            fallValue = 0.0f;
            ChangeState(State.Fall);
        }
        else if(jumpTimeoutDelta + vertical * 0.1f < 0.0f)
        {
            slope.canRotate = true;
            ChangeState(State.Locomotion);
        }
    }

 
    private void FallUpdate()
    {
        controller.Move(gravityVelocity * Vector3.down * Time.deltaTime);
        controller.Move(fallVelocity * transform.forward * 2.0f * Time.deltaTime);
        vertical -= 10.0f * Time.deltaTime;
        fallValue += 2.0f * Time.deltaTime;

        if (slope.Height < 1.0f)
        {
            frontHoesRig.weight = Mathf.Lerp(frontHoesRig.weight, 1.0f, Time.deltaTime);
            if (Physics.Raycast(frontLeftHoe.position, Vector3.down, out RaycastHit leftHit, Mathf.Infinity))
            {
                frontLeftHoeTarget.position = leftHit.point;
            }
            if (Physics.Raycast(frontRightHoe.position, Vector3.down, out RaycastHit rightHit, Mathf.Infinity))
            {
                frontRightHoeTarget.position = rightHit.point;
            }
        }

        if (slope.IsGround || slope.Height < 0.2f)
        {
            if (0.1f < fallVelocity)
            {
                vertical = fallVelocity;
                ChangeState(State.Locomotion);
            }
            else
            {
                vertical = 0.0f;
                ChangeState(State.Idle);
            }
            frontHoesRig.weight = 0.0f;
            fallTimeoutDelta = fallTimeout;
        }
    }


    private void ChangeState(State newState)
    {
        if (state != newState)
        {
            lastState = state;
            state = newState;
        }
    }
}
