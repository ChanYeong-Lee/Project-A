using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using UnityEngine;
using UnityEngine.SceneManagement;
using AsyncOperation = UnityEngine.AsyncOperation;

public class SceneLoadManager
{
    public void LoadScene(Define.SceneType sceneType)
    {
        SceneManager.LoadScene(Enum.GetName(typeof(Define.SceneType), sceneType));
    }

    public IEnumerator LoadSceneAsync(Define.SceneType sceneType)
    {
        yield return null;
        
        AsyncOperation operation = SceneManager.LoadSceneAsync(sceneType.ToString());
        float loadingTime = Define.MinSceneLoadingTime;
        float progress = 0f;
        
        operation.allowSceneActivation = false;

        while (!operation.isDone)
        {
            yield return null;
            loadingTime -= Time.fixedDeltaTime;
            Managers.UI.LoadingUI.LoadingAmount = progress;

            if (operation.progress < 0.9f)
            {
                progress = Mathf.Clamp01(operation.progress);
            }
            else switch (loadingTime)
            {
                case > 0f:
                    progress = operation.progress + (Define.MinSceneLoadingTime - loadingTime) / Define.MinSceneLoadingTime * 0.1f; 
                    break;
                case < 0f:
                    progress = Mathf.Clamp01(operation.progress / 0.9f);
                    yield return null;
                    loadingTime = Define.MinSceneLoadingTime;
                    operation.allowSceneActivation = true;
                    break;
            }
        }
    }
    
    public void Clear()
    {
    }
}