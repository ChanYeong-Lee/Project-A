using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Animations.Rigging;
using UnityEngine.Windows;

public class CharacterMount : MonoBehaviour
{
    [SerializeField] private Horse horse;
    [SerializeField] private Rig mountRig;
    
    [SerializeField] private TwoBoneIKConstraint leftFootIK;
    [SerializeField] private TwoBoneIKConstraint rightFootIK;

    private CharacterMove move;
    private Animator animator;
    private CharacterController characterController;

    private float mountTime = 1.667f;

    private bool isMount = false;

    private float ratio = 0.0f;
    private Vector3 originPos;
    private Quaternion originRot;

    private void Awake()
    {
        move = GetComponent<CharacterMove>();
        animator = GetComponent<Animator>();
        characterController = GetComponent<CharacterController>();
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

    private void Update()
    {
        if (move.GetComponent<PlayerInputAsset>().state == PlayerInputAsset.State.Mount)
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
       
        move.SetMount(true);

        horse.GetComponent<HorseMove>().enabled = true;
        horse.GetComponent<HorseMove>().Mount(move.PInput, animator);
    }


}
