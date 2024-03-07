using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HeadAimTarget : MonoBehaviour
{
    private Transform horse;

    private void Start()
    {   
        horse = Managers.Game.Horse.transform;
    }

    private void LateUpdate()
    {
        transform.position = horse.position + horse.forward * 20.0f + horse.up * 1.2f;
    }
}
