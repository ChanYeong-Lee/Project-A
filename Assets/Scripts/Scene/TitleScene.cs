using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TitleScene : MonoBehaviour
{
    private void Start()
    {
        Managers.Game.ChangeFullScreen(100);
        Managers.Input.Input.Disable();
    }
}
