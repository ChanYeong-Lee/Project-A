using System;
using UnityEngine.SceneManagement;

public class SceneLoadManager
{
    public void LoadScene(Define.SceneType sceneType)
    {
        SceneManager.LoadScene(Enum.GetName(typeof(Define.SceneType), sceneType));
    }

    public void Clear()
    {
    }
}