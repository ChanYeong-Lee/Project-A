using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using UnityEngine;
using UnityEngine.SceneManagement;
using AsyncOperation = UnityEngine.AsyncOperation;

public class SceneLoadManager
{
    // TODO : 씬 로딩 수정한걸로 바꾸기!!
    public void LoadScene(Define.SceneType sceneType)
    {
        SceneManager.LoadScene(Enum.GetName(typeof(Define.SceneType), sceneType));
    }

    public IEnumerator LoadSceneAsync(Define.SceneType sceneType)
    {
        yield return null;
        
        // 씬을 비동기로 로드
        AsyncOperation operation = SceneManager.LoadSceneAsync(sceneType.ToString());

        operation.allowSceneActivation = false;
        float loadingTime = Define.FideLoadingTime;
        float progress = 0f;
        // 로딩이 완료될 때까지 대기
        while (!operation.isDone)
        {
            yield return null;
            Managers.UI.LoadingUI.LoadingAmount = progress;
            loadingTime -= Time.fixedDeltaTime;
            Debug.Log(loadingTime);
            
            if (operation.progress < 0.9f)
            {
                progress = Mathf.Clamp01(operation.progress); // 로딩 완료가 0.9로 간주
            }
            else switch (loadingTime)
            {
                case > 0f:
                    progress = operation.progress + (Define.FideLoadingTime - loadingTime) / Define.FideLoadingTime * 0.1f; 
                    break;
                case < 0f:
                    progress = Mathf.Clamp01(operation.progress / 0.9f);
                    yield return null;
                    loadingTime = Define.FideLoadingTime;
                    operation.allowSceneActivation = true;
                    break;
            }
        }

        // 로딩 화면을 비활성화
        // Managers.UI.LoadingUI.gameObject.SetActive(false);
    }
    
    public void Clear()
    {
    }
}