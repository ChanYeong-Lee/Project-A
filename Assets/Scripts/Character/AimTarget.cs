using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AimTarget : MonoBehaviour
{
    [SerializeField] private float distance;


    private Vector3 targetPos;

    private Transform target;
    private float offset = 0.0f;
    private float angle = 0.0f;

    private void LateUpdate()
    {
        if (target != null)
        {
            float targetDistance = Vector3.Distance(transform.position, target.position);
            offset = targetDistance * Mathf.Tan(angle * Mathf.Deg2Rad);
            targetPos = target.position + offset * Vector3.up;
        }
        else
        {
            offset = distance * Mathf.Tan(angle * Mathf.Deg2Rad);
            targetPos = Camera.main.transform.position + Camera.main.transform.forward * distance + offset * Vector3.up;
        }

        transform.position = targetPos;
    }

    public void SetAngle(float angle)
    {
        this.angle = Mathf.Clamp(angle, -45.0f, 45.0f);
    }

    public void SetTarget(Transform target)
    {
        this.target = target;
    }
}
