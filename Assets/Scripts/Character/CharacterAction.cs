using UnityEngine;
using UnityEngine.Animations.Rigging;

public class CharacterAction : MonoBehaviour
{
    [SerializeField] private Rig bodyAimRig;
    [SerializeField] private Rig bowPosRig;
    [SerializeField] private Rig mountHeadAimRig;
    [SerializeField] private TwoBoneIKConstraint bowPosIK;
    [SerializeField] private Transform bowPosTarget;
    [SerializeField] private Transform bowPosDefaultTarget;
    [SerializeField] private Transform bowPosMountTarget;

    private Animator animator;
    private CharacterMove move;
    private CharacterMount mount;
    
    private float bodyAimRigVelocity = 0.0f;
    private float bowPosRigVelocity = 0.0f;
    private float mountHeadAimRigVelocity = 0.0f;

    private bool isMount = false;

    private void Awake()
    {
        move = GetComponent<CharacterMove>();
        mount = GetComponent<CharacterMount>();
        animator = GetComponent<Animator>();
    }

    private void OnEnable()
    {
        bodyAimRig.weight = 0.0f;
        bowPosRig.weight = 0.75f;
        mountHeadAimRig.weight = 0.0f;
    }

    private void Update()
    {
        if (move.IsAim)
        {
            bodyAimRig.weight = Mathf.SmoothDamp(bodyAimRig.weight, 1.0f, ref bodyAimRigVelocity, 0.2f);
            bowPosRig.weight = Mathf.SmoothDamp(bowPosRig.weight, 0.0f, ref bowPosRigVelocity, 0.2f);
            if (isMount)
            {
                mountHeadAimRig.weight = Mathf.SmoothDamp(mountHeadAimRig.weight, 0.0f, ref mountHeadAimRigVelocity, 0.2f);
            }
            else
            {
                mountHeadAimRig.weight = 0.0f;
            }
        }
        else
        {
            bodyAimRig.weight = Mathf.SmoothDamp(bodyAimRig.weight, 0.0f, ref bodyAimRigVelocity, 0.2f);
            bowPosRig.weight = Mathf.SmoothDamp(bowPosRig.weight, 0.75f, ref bowPosRigVelocity, 0.2f);
            if (isMount)
            {
                mountHeadAimRig.weight = Mathf.SmoothDamp(mountHeadAimRig.weight, 1.0f, ref mountHeadAimRigVelocity, 0.2f);
            }
            else
            {
                mountHeadAimRig.weight = 0.0f;
            }
        }

        bowPosTarget.position = isMount ? bowPosMountTarget.position : bowPosDefaultTarget.position;
        bowPosTarget.rotation = isMount ? bowPosMountTarget.rotation : bowPosDefaultTarget.rotation;

        // TODO : UI 인벤토리 확인을 위해 잠시 주석 처리
        // if (Input.GetKeyDown(KeyCode.F))
        // {
        //     isMount = !isMount;
        //     animator.SetBool("Mount", isMount);
        //     animator.SetTrigger("MountTrigger");
        //     if (isMount)
        //     {
        //         mount.StartMount();
        //     }
        // }
    }
}
