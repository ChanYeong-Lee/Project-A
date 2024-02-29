using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotation : MonoBehaviour
{
    [SerializeField] private float rotationPeriod = 10.0f;
    [SerializeField] private float minAngle = 10.0f;
    [SerializeField] private float maxAngle = -245.0f;

    private float angle = 0.0f;
    void Update()
    {
        angle = Mathf.Lerp(minAngle, maxAngle, 0.5f - Mathf.Cos(Time.time * Mathf.PI / rotationPeriod) * 0.5f);
        transform.rotation = Quaternion.Euler(0, angle, 0);
    }
}
