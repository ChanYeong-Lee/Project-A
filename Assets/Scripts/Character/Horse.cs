using UnityEngine;

public class Horse : MonoBehaviour
{
    [SerializeField] private Transform[] mountPointIKs;
    [SerializeField] private Transform mountPoint;
    [SerializeField] private GameObject headAimTarget;

    public enum MountIK
    {
        LeftFoot = 0,
        LeftKnee = 1,
        RightFoot = 2,
        RightKnee = 3
    }
        
    public Transform[] MountPointIKs => mountPointIKs;
    public Transform MountPoint => mountPoint;
    public GameObject HeadAimTarget => headAimTarget;
}
