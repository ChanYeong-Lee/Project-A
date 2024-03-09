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
        // 씬을 비동기로 로드
        AsyncOperation operation = SceneManager.LoadSceneAsync(sceneType.ToString());

        // 로딩이 완료될 때까지 대기
        while (!operation.isDone)
        {
            // 로딩 상태를 표시할 수도 있음 (예: 로딩 바 갱신)
            float progress = Mathf.Clamp01(operation.progress / 0.9f); // 로딩 완료가 0.9로 간주
            Managers.UI.LoadingUI.loadingAmount = progress;
            Debug.Log($"{progress}");
            // 로딩이 완료될 때까지 대기
            yield return null;
        }

        // 로딩 화면을 비활성화
        Managers.UI.LoadingUI.gameObject.SetActive(false);
    }
    
    public void Clear()
    {
    }
}