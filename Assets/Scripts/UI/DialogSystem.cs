using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class DialogSystem : UIBase
{
    public DialogData[] dialogDatas;

    public int currentSpeakerIndex = 0;
    public int currentDialogIndex = -1;
    private float typingSpeed = 0.1f;

    private bool isFirst = true;
    private bool isAutoStart = true;
    private bool isTypingEffect = true;

    protected override void Awake()
    {
        base.Awake();
    }
    void Start()
    {
       // BindDialog(currentSpeakerIndex, false) ;
        buttons["ArrowButton"].onClick.AddListener(() => SkipOrNextDialog());
        UpdateDialog();
       
    }
    private void Update()
    {
       
        if(currentSpeakerIndex > dialogDatas.Length)
        {
            Managers.UI.CloseDialogUI();
        }
    }
    private void BindDialog(int currentSpeakerIndex, bool visible)
    {
        if (visible && currentSpeakerIndex+1 < dialogDatas.Count())
        {
            texts["TextDialog"].text = dialogDatas[currentSpeakerIndex].dialog;
            texts["NameText"].text = dialogDatas[currentSpeakerIndex].name;
            texts["TextDialog"].gameObject.SetActive(visible);
            texts["NameText"].gameObject.SetActive(visible);
            buttons["ArrowButton"].gameObject.SetActive(false);
        }
    }

    private void SkipOrNextDialog()
    {
        SetNextDialog();
        // ���� ��縦 �����ϵ��� 
        currentSpeakerIndex++;
        if (currentSpeakerIndex + 1 > dialogDatas.Count())
        {
            Managers.UI.CloseDialogUI();
        }
    }
    public bool UpdateDialog()
    {
        // ��� �бⰡ ���۵� �� 1ȸ�� ȣ��
        if (isFirst == true)
        {
            
            // �ڵ� ���(isAutoStart=true)���� �����Ǿ� ������ ù ��° ��� ���
            if (isAutoStart) SetNextDialog();

            isFirst = false;
        }
        if (Managers.Input.leftClick)
        {
            // �ؽ�Ʈ Ÿ���� ȿ���� ������϶� ���콺 ���� Ŭ���ϸ� Ÿ���� ȿ�� ����
            if (isTypingEffect == true)
            {
                isTypingEffect = false;

                // Ÿ���� ȿ���� �����ϰ�, ���� ��� ��ü�� ����Ѵ�
                StopCoroutine("OnTypingText");
                texts["DialogText"].text = dialogDatas[currentSpeakerIndex].dialog;
                // ��簡 �Ϸ�Ǿ��� �� ��µǴ� Ŀ�� Ȱ��ȭ
                buttons["ArrowButton"].gameObject.SetActive(true);
            }
        }



        return false;
    }
    private void SetNextDialog()
    {
     
        BindDialog(currentSpeakerIndex, false);

        // ���� ȭ�� ���� ����
        currentSpeakerIndex = dialogDatas[currentSpeakerIndex].speakerIndex;

        BindDialog(currentSpeakerIndex, true);
      
        StartCoroutine("OnTypingText");
       

    }

   
    private IEnumerator OnTypingText()
    {
        buttons["ArrowButton"].gameObject.SetActive(false);
        int index = 0;
        while (index < dialogDatas[currentSpeakerIndex].dialog.Length) 
        {
            texts["TextDialog"].text = dialogDatas[currentSpeakerIndex].dialog.Substring(0, index);
            index++;

            yield return null;
            yield return new WaitForSeconds(typingSpeed);
        }
        buttons["ArrowButton"].gameObject.SetActive(true);
    }





}
[Serializable]
public struct DialogData
{
    public int speakerIndex;    // �̸��� ��縦 ����� ���� DialogSystem�� speakers �迭 ����
    public string name;         // ĳ���� �̸�
    [TextArea(3, 5)]
    public string dialog;		// ���
}
