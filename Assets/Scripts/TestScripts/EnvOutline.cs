using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnvOutline : MonoBehaviour
{
    [SerializeField] private Material outline;

    private void OnEnable()
    {
        outline.SetFloat("_Thickness", 23);
    }

    private void OnDisable()
    {
        outline.SetFloat("_Thickness", 0);

    }
}
