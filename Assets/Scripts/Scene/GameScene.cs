using System;
using UnityEngine;

public class GameScene : MonoBehaviour
{
    [Range(0f, 16f)] public float gameSpeed = 1f ;

    private void Awake()
    {
        Managers.Game.Init();
        Managers.Data.Init();
        Managers.UI.Init();
        Managers.Cursor.ChangeCursorState(CursorManager.CursorState.OnGame);
    }

    private void Update()
    {
        Managers.Game.GameSpeed = gameSpeed;
    }
}