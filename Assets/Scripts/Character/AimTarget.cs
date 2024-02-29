using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AimTarget : MonoBehaviour
{
    [SerializeField] private float offset;

    private void Update()
    {
        transform.position = Camera.main.transform.position + Camera.main.transform.forward * offset;
        transform.rotation = Camera.main.transform.rotation;
    }
}
