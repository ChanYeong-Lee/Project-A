using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnvOutline : MonoBehaviour
{
    [SerializeField] private Material outline;

    private void OnEnable()
    {
        outline.SetFloat("_IsScanning", 1);
    }

    private void OnDisable()
    {
        outline.SetFloat("_IsScanning", 0);
    }
}
