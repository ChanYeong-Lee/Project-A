using System;
using UnityEngine;

public class LoadingScene : MonoBehaviour
{
    private void Start()
    {
        Managers.UI.CreateLoadingUI();
        StartCoroutine(Managers.Scene.LoadSceneAsync(Define.SceneType.GameScene));
        Managers.Input.Input.Disable();
    }
}