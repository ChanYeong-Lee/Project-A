using UnityEngine;

public class Horse : MonoBehaviour
{
    [SerializeField] private Transform[] mountPointIKs;
    [SerializeField] private Transform mountPoint;

    public enum MountIK
    {
        LeftFoot = 0,
        LeftKnee = 1,
        RightFoot = 2,
        RightKnee = 3
    }
        
    public Transform[] MountPointIKs => mountPointIKs;
    public Transform MountPoint => mountPoint;
}
