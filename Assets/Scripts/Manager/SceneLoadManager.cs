using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using UnityEngine;
using UnityEngine.SceneManagement;
using AsyncOperation = UnityEngine.AsyncOperation;

public class SceneLoadManager
{
    // TODO : �� �ε� �����Ѱɷ� �ٲٱ�!!
    public void LoadScene(Define.SceneType sceneType)
    {
        SceneManager.LoadScene(Enum.GetName(typeof(Define.SceneType), sceneType));
    }

    public IEnumerator LoadSceneAsync(Define.SceneType sceneType)
    {
        yield return null;
        
        // ���� �񵿱�� �ε�
        AsyncOperation operation = SceneManager.LoadSceneAsync(sceneType.ToString());

        operation.allowSceneActivation = false;
        float loadingTime = Define.FideLoadingTime;
        float progress = 0f;
        // �ε��� �Ϸ�� ������ ���
        while (!operation.isDone)
        {
            yield return null;
            Managers.UI.LoadingUI.LoadingAmount = progress;
            loadingTime -= Time.fixedDeltaTime;
            Debug.Log(loadingTime);
            
            if (operation.progress < 0.9f)
            {
                progress = Mathf.Clamp01(operation.progress); // �ε� �Ϸᰡ 0.9�� ����
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

        // �ε� ȭ���� ��Ȱ��ȭ
        // Managers.UI.LoadingUI.gameObject.SetActive(false);
    }
    
    public void Clear()
    {
    }
}