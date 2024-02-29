using System.Collections;
using UnityEngine;
using UnityEngine.Animations.Rigging;

public class CharacterMount : MonoBehaviour
{
    [SerializeField] private Horse horse;
    [SerializeField] private Rig mountRig;
    
    [SerializeField] private TwoBoneIKConstraint leftFootIK;
    [SerializeField] private TwoBoneIKConstraint rightFootIK;

    private PlayerMove move;
    private Animator animator;
    private CharacterController characterController;

    private float mountTime = 1.667f;

    private bool isMount = false;

    float ratio = 0.0f;
    Vector3 originPos;
    Quaternion originRot;

    private void Awake()
    {
        move = GetComponent<PlayerMove>();
        animator = GetComponent<Animator>();
        characterController = GetComponent<CharacterController>();
    }

    private void OnEnable()
    {
        mountRig.weight = 0.0f;
    }

    private void Update()
    {
        if (move.GetComponent<PlayerInput>().state == PlayerInput.State.Mount)
        {
            transform.localPosition = Vector3.zero;
            transform.localRotation = Quaternion.identity;
        }
    }

    public void StartMount()
    {
       characterController.enabled = false;
       transform.parent = horse.MountPoint;

       isMount = true;

       ratio = 0.0f;
       originPos = transform.position;
       originRot = transform.rotation;
       StartCoroutine(MountCoroutine());
    }

    private IEnumerator MountCoroutine()
    {

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
       
        //move.GetComponent<StarterAssetsInputs>().state = StarterAssetsInputs.State.Mount;
        move.isMount = true;

        horse.GetComponent<HorseMoveWithStateMachine>().enabled = true;
        //horse.GetComponent<HorseMove>().enabled = true;
        //horse.GetComponent<HorseMove>().input = move.PInput;
        horse.GetComponent<HorseMoveWithStateMachine>().input = move.PInput;
        horse.GetComponent<HorseMoveWithStateMachine>().characterAnimator = move.PAnimator;
    }

    //private void OnAnimatorIK(int layerIndex)
    //{
    //    if (isMount && ratio <= 1.0f)
    //    {
    //        ratio += Time.deltaTime / mountTime;

    //        transform.position = Vector3.Lerp(originPos, horse.MountPoint.position, ratio);
    //        transform.rotation = Quaternion.Slerp(originRot, horse.MountPoint.rotation, ratio);

    //        //animator.SetIKPositionWeight(AvatarIKGoal.LeftFoot, ratio);
    //        //animator.SetIKHintPositionWeight(AvatarIKHint.LeftKnee, ratio);
    //        //animator.SetIKPositionWeight(AvatarIKGoal.RightFoot, ratio);
    //        //animator.SetIKHintPositionWeight(AvatarIKHint.RightKnee, ratio);

    //        //animator.SetIKPosition(AvatarIKGoal.LeftFoot, horse.MountPointIKs[(int)Horse.MountIK.LeftFoot].position);
    //        //animator.SetIKHintPosition(AvatarIKHint.LeftKnee, horse.MountPointIKs[(int)Horse.MountIK.LeftKnee].position);
    //        //animator.SetIKPosition(AvatarIKGoal.RightFoot, horse.MountPointIKs[(int)Horse.MountIK.RightFoot].position);
    //        //animator.SetIKHintPosition(AvatarIKHint.RightKnee, horse.MountPointIKs[(int)Horse.MountIK.RightKnee].position);
    //    }
    //    else
    //    {
    //        ratio = 10.0f;
    //    }
    //}
}
