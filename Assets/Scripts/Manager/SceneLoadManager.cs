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
        // ���� �񵿱�� �ε�
        AsyncOperation operation = SceneManager.LoadSceneAsync(sceneType.ToString());

        // �ε��� �Ϸ�� ������ ���
        while (!operation.isDone)
        {
            // �ε� ���¸� ǥ���� ���� ���� (��: �ε� �� ����)
            float progress = Mathf.Clamp01(operation.progress / 0.9f); // �ε� �Ϸᰡ 0.9�� ����
            Managers.UI.LoadingUI.loadingAmount = progress;
            Debug.Log($"{progress}");
            // �ε��� �Ϸ�� ������ ���
            yield return null;
        }

        // �ε� ȭ���� ��Ȱ��ȭ
        Managers.UI.LoadingUI.gameObject.SetActive(false);
    }
    
    public void Clear()
    {
    }
}