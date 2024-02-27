using MalbersAnimations;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HorseSlope : MonoBehaviour
{
    [SerializeField] private Transform frontLeftHoe;
    [SerializeField] private Transform frontRightHoe;
    [SerializeField] private Transform rearLeftHoe;
    [SerializeField] private Transform rearRightHoe;

    RaycastHit frontLeftHit;
    RaycastHit frontRightHit;
    RaycastHit rearLeftHit;
    RaycastHit rearRightHit;

    public bool frontLeftGround = false;
    public bool frontRightGround = false;
    public bool rearLeftGround = false;
    public bool rearRightGround = false;
    public bool isGround = false;

    private Vector3 frontPoint = Vector3.zero;
    private Vector3 rearPoint = Vector3.zero;

    private float pitch = 0.0f;
    private float height = 0.0f;

    public float Pitch => pitch;
    public float Height => height;

    public bool IsGround => isGround;
    
    [SerializeField] private float groundOffset = -0.14f;
    [SerializeField] private float groundDistance = 0.28f;
    [SerializeField] private LayerMask groundLayers;
    [SerializeField] private float rotateSpeed = 1.0f;


    // Update is called once per frame
    private void Update()
    {
        CheckHeight();
        CheckHoes();
        RotateBody();
    }

    private void CheckHoes()
    {
        if (CheckHoeIsGround(frontLeftHoe, out frontLeftHit))
        {
            frontPoint = frontLeftHit.point;
            frontLeftGround = true;
        }
        else
        {
            frontLeftGround = false;
        }

        if (CheckHoeIsGround(frontRightHoe, out frontRightHit))
        {
            frontPoint = frontRightHit.point;
            frontRightGround = true;
        }
        else
        {
            frontRightGround = false;
        }

        if (!frontRightGround && !frontLeftGround)
        {
            frontPoint = rearPoint + transform.forward * 0.5f + Vector3.up * (-10.0f);
        }


        if (CheckHoeIsGround(rearLeftHoe, out rearLeftHit))
        {
            rearPoint = rearLeftHit.point;
            rearLeftGround = true;
        }
        else
        {
            rearLeftGround = false;
        }

        if (CheckHoeIsGround(rearRightHoe, out rearRightHit))
        {
            rearPoint = rearRightHit.point;
            rearRightGround = true;
        }
        else
        {
            rearRightGround = false;
        }

        if (frontLeftGround || frontRightGround || rearLeftGround || rearRightGround)
        {
            isGround = true;
        }
        else
        {
            isGround = false;
        }

    }

    private void CheckHeight()
    {
        if (Physics.Raycast(transform.position, Vector3.down, out RaycastHit hit, Mathf.Infinity))
        {
            height = hit.distance;
        }
        else
        {
            height = 0.0f;
        }
    }


    private void RotateBody()
    {
        if (isGround)
        {
            float deltaX = Vector3.Dot(transform.forward, frontPoint - rearPoint);
            float deltaY = frontPoint.y - rearPoint.y;
            pitch = Mathf.Atan2(deltaY, deltaX) * Mathf.Rad2Deg;

            pitch = Mathf.Clamp(pitch, -40, 40);

            //print($"{deltaX}, {deltaY}, pitch = {pitch}");
        }
        else
        {
            pitch = 0.0f;
        }
        transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.Euler(-pitch, transform.rotation.eulerAngles.y, 0), Time.deltaTime * rotateSpeed);
        //else
        //{
        //    pitch += Time.deltaTime;
        //}

        
    }

    private bool CheckHoeIsGround(Transform hoePos, out RaycastHit hit)
    {
        return Physics.Raycast(hoePos.position + Vector3.up * groundOffset, Vector3.down, out hit, groundDistance);
    }

}
