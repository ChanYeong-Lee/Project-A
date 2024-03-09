using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class GameOverUI : MonoBehaviour
{
    private void Update()
    {
        if (Keyboard.current.anyKey.wasPressedThisFrame)
        {
            Managers.Clear();
            Managers.Scene.LoadScene(Define.SceneType.TitleScene);
        }
    }
}
