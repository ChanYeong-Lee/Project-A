using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Animations.Rigging;
using UnityEngine.Windows;

public class CharacterMount : MonoBehaviour
{
    public enum MountState 
    { 
        DisMount,
        Mounting,
        Mount,
        DisMounting,
    }

    private MountState state;
    public MountState State => state;

    private Coroutine actionCoroutine;

    [SerializeField] private Horse horse;

    [SerializeField] private Rig mountRig;
    [SerializeField] private TwoBoneIKConstraint leftFootIK;
    [SerializeField] private TwoBoneIKConstraint rightFootIK;

    private CharacterMove move;
    private Animator animator;
    private CharacterController characterController;

    private float mountTime = 1.667f;

    private void Awake()
    {
        move = GetComponent<CharacterMove>();
        animator = GetComponent<Animator>();
        characterController = GetComponent<CharacterController>();
    }

    private void Update()
    {
        switch (state)
        {
            case MountState.DisMount:
                if (Managers.Input.hKey)
                {
                    StartMount();
                    Managers.Input.hKey = false;
                }
                break;
            case MountState.Mount:
                if (Managers.Input.hKey)
                {
                    StartDisMount();
                    Managers.Input.hKey = false;
                }
                break;
            default:
                break;
        }
    }

    private void Start()
    {
        if (horse == null) 
            horse = Managers.Game.Horse.GetComponent<Horse>();
    }

    private void OnEnable()
    {
        mountRig.weight = 0.0f;
    }

    public void StartMount()
    {
        if (actionCoroutine != null) return;
        
        animator.SetBool("Mount", true);
        actionCoroutine = StartCoroutine(MountCoroutine());
    }

    public void StartDisMount()
    {
        if (actionCoroutine != null) return;
        
        animator.SetBool("Mount", false);
        actionCoroutine = StartCoroutine(MountCoroutine());
    }

    private IEnumerator MountCoroutine()
    {
        state = MountState.Mounting;

        horse.transform.position = transform.position + transform.right * 5.0f;
        horse.gameObject.SetActive(true);

        characterController.enabled = false;
        transform.parent = horse.MountPoint;

        float ratio = 0.0f;
        Vector3 originPos = transform.position;
        Quaternion originRot = transform.rotation;

        while (true)
        {
            if (0.0f < mountTime)
            {
                ratio += Time.deltaTime / mountTime;
            }

            transform.position = Vector3.Lerp(originPos, horse.MountPoint.position, ratio);
            transform.rotation = Quaternion.Slerp(originRot, horse.MountPoint.rotation, ratio);

            leftFootIK.data.target.position = horse.MountPointIKs[(int)Horse.MountIK.LeftFoot].position;
            leftFootIK.data.hint.position = horse.MountPointIKs[(int)Horse.MountIK.LeftKnee].position;
            rightFootIK.data.target.position = horse.MountPointIKs[(int)Horse.MountIK.RightFoot].position;
            rightFootIK.data.hint.position = horse.MountPointIKs[(int)Horse.MountIK.RightKnee].position;

            mountRig.weight = ratio;

            yield return null;

            if (1.0f <= ratio)
            {
                break;
            }
        }
       
        move.SetMount(true);

        horse.GetComponent<HorseMove>().enabled = true;
        horse.GetComponent<HorseMove>().Mount(animator);

        state = MountState.Mount;
        actionCoroutine = null;
    }

    private IEnumerator DisMountCoroutine()
    {
        state = MountState.DisMounting;

    

        float ratio = 0.0f;
        
        Vector3 originPos = transform.position;
        Quaternion originRot = transform.rotation;

        Vector3 targetPos = horse.transform.position + horse.transform.right * (-5.0f);
        Quaternion targetRot = horse.transform.rotation * Quaternion.Euler(0.0f, 90.0f, 0.0f);

        while (true)
        {
            if (0.0f < mountTime)
            {
                ratio += Time.deltaTime / mountTime;
            }

            transform.position = Vector3.Lerp(originPos, targetPos, ratio);
            transform.rotation = Quaternion.Slerp(originRot, targetRot, ratio);

            leftFootIK.data.target.position = leftFootIK.data.tip.position;
            leftFootIK.data.hint.position = leftFootIK.data.mid.position;
            rightFootIK.data.target.position = rightFootIK.data.tip.position;
            rightFootIK.data.hint.position = rightFootIK.data.mid.position;

            mountRig.weight = 1.0f - ratio;

            yield return null;

            if (1.0f <= ratio)
            {
                break;
            }
        }

        move.SetMount(false);

        characterController.enabled = true;
        transform.parent = null;

        horse.GetComponent<HorseMove>().enabled = false;
        horse.gameObject.SetActive(false);
        
        state = MountState.DisMount;
        actionCoroutine = null;
    }
}
