using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEngine;

public class HorseSlope : MonoBehaviour
{
    [SerializeField] private Transform frontLeftHoe;
    [SerializeField] private Transform frontRightHoe;
    [SerializeField] private Transform rearLeftHoe;
    [SerializeField] private Transform rearRightHoe;

    [SerializeField] private GameObject footPrint;

    [Header("Ground Check")]
    [SerializeField] private float groundOffset = 0.5f;
    [SerializeField] private float groundDistance = 0.55f;
    [SerializeField] private LayerMask groundLayers;
    [SerializeField] private float groundTimeout = 0.25f;
    [SerializeField] private float groundTimeoutDelta = 0.0f;

    private GameObject frontRightFootPrint;
    private GameObject rearRightFootPrint;
    private GameObject frontLeftFootPrint;
    private GameObject rearLeftFootPrint;

    private HorseMove move;

    private RaycastHit frontLeftHit;
    private RaycastHit frontRightHit;
    private RaycastHit rearLeftHit;
    private RaycastHit rearRightHit;

    public bool frontLeftGround = false;
    public bool frontRightGround = false;
    public bool rearLeftGround = false;
    public bool rearRightGround = false;
    public bool isGround = false;

    private Vector3 frontPoint = Vector3.zero;
    private Vector3 rearPoint = Vector3.zero;

    private float pitch = 0.0f;
    private float posHeight = 0.0f;
    private float frontHoeHeight = 0.0f;

    // properties
    public float Pitch => pitch;
    public float Height => posHeight;
    public float HoeHeight => frontHoeHeight;

    public bool IsGround => isGround;

    public bool canRotate;

    

    private Vector3 p1 = Vector3.zero;
    private Vector3 p2 = Vector3.zero;

    private void Awake()
    {
        move = GetComponent<HorseMove>();
    }

    private void OnEnable()
    {
        frontRightFootPrint = Instantiate(footPrint, frontRightHoe.position, frontRightHoe.rotation);
        rearRightFootPrint = Instantiate(footPrint, rearRightHoe.position, rearRightHoe.rotation);
        frontLeftFootPrint = Instantiate(footPrint, frontLeftHoe.position, frontLeftHoe.rotation);
        rearLeftFootPrint = Instantiate(footPrint, rearLeftHoe.position, rearLeftHoe.rotation);

        canRotate = true;
    }

    private void Update()
    {
        CheckHeight();
        CheckGround();
        CheckHoes();
        RotateBody();
    }

    private void CheckHoes()
    {
        if (CheckHoeIsGround(frontLeftHoe, out frontLeftHit))
        {
            frontPoint = frontLeftHit.point;
            frontRightFootPrint.transform.position = frontPoint;
            frontRightFootPrint.transform.rotation = Quaternion.LookRotation(frontLeftHit.normal);
            frontLeftGround = true;
        }
        else
        {
            frontLeftGround = false;
        }

        if (CheckHoeIsGround(frontRightHoe, out frontRightHit))
        {
            frontPoint = frontRightHit.point;
            frontLeftFootPrint.transform.position = frontPoint;
            frontLeftFootPrint.transform.rotation = frontRightHoe.rotation;
            frontRightGround = true;
        }
        else
        {
            frontRightGround = false;
        }

        if (!frontRightGround && !frontLeftGround)
        {
            frontPoint += transform.forward - transform.up;
        }


        if (CheckHoeIsGround(rearLeftHoe, out rearLeftHit))
        {
            rearPoint = rearLeftHit.point;
            rearLeftFootPrint.transform.position = rearPoint;
            rearLeftFootPrint.transform.rotation = Quaternion.LookRotation(frontLeftHit.normal);
            rearLeftGround = true;
        }
        else
        {
            rearLeftGround = false;
        }

        if (CheckHoeIsGround(rearRightHoe, out rearRightHit))
        {
            rearPoint = rearRightHit.point;
            rearRightFootPrint.transform.position = rearPoint;
            rearRightFootPrint.transform.rotation = Quaternion.LookRotation(frontLeftHit.normal);
            rearRightGround = true;
        }
        else
        {
            rearRightGround = false;
        }
    }

    private void CheckHeight()
    {
        if (Physics.Raycast(transform.position + transform.up, -transform.up, out RaycastHit hit1, Mathf.Infinity, groundLayers))
        {
            posHeight = Vector3.Magnitude(transform.position - hit1.point);
        }
        else
        {
            posHeight = 0.0f;
        }

        if (Physics.Raycast(frontLeftHoe.position + Vector3.up, Vector3.down, out RaycastHit hit2, Mathf.Infinity, groundLayers))
        {
            frontHoeHeight = Vector3.Magnitude(transform.position + transform.forward * 1.2f - hit2.point);
        }
        else
        {
            frontHoeHeight = 0.0f;
        }
    }

    private void CheckGround()
    {
        if (isGround)
        {
            groundTimeoutDelta = groundTimeout;
        }
        
        if (frontLeftGround || frontRightGround || rearLeftGround || rearRightGround)
        {
            isGround = true;
        }
        else
        {
            groundTimeoutDelta -= Time.deltaTime;
            if (groundTimeoutDelta < 0.0f)
            {
                isGround = false;
            }

            if (0.5f < posHeight)
            {
                isGround = false;
            }
        }
    }

    private void RotateBody()
    {
        CheckSlope();

        float rotateSpeed = 2 + move.MoveSpeed;

        if (canRotate)
        {
            transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.Euler(-pitch, transform.rotation.eulerAngles.y, 0), rotateSpeed * Time.deltaTime);
        }
    }

    

    private void CheckSlope()
    {
        if (Physics.Raycast(transform.position + transform.forward * 1.2f+ Vector3.up, Vector3.down, out RaycastHit frontRightHit2, Mathf.Infinity, groundLayers))
        {
            p1 = frontRightHit2.point;
        }

        if (Physics.Raycast(transform.position + Vector3.up, Vector3.down, out RaycastHit rearLeftHit2, Mathf.Infinity, groundLayers))
        {
            p2 = rearLeftHit2.point;
        }

        Vector3 forward = transform.forward;
        forward.y = 0;
        forward.Normalize();

        float deltaX = Vector3.Dot(forward, p1 - p2);
        float deltaY = p1.y - p2.y;
        if (isGround)
        {
            pitch = Mathf.Atan2(deltaY, deltaX) * Mathf.Rad2Deg;
        }
        else if(posHeight < 0.5f)
        {
            //pitch -= 40.0f * Time.deltaTime;
        }
        pitch = Mathf.Clamp(pitch, -40.0f, 40.0f);
    }

    private bool CheckHoeIsGround(Transform hoePos, out RaycastHit hit)
    {
        return Physics.Raycast(hoePos.position + Vector3.up * groundOffset, -Vector3.up, out hit, groundDistance, groundLayers);
    }
}