using System;
using UnityEngine;

public class GameScene : MonoBehaviour
{
    [Range(1f, 16f)] public float gameSpeed = 1f ;

    private void Start()
    {
        
    }

    private void Update()
    {
        Managers.Game.GameSpeed = gameSpeed;
    }
}