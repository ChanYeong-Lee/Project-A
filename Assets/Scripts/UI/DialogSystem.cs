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
        // 다음 대사를 진행하도록 
        currentSpeakerIndex++;
        if (currentSpeakerIndex + 1 > dialogDatas.Count())
        {
            Managers.UI.CloseDialogUI();
        }
    }
    public bool UpdateDialog()
    {
        // 대사 분기가 시작될 때 1회만 호출
        if (isFirst == true)
        {
            
            // 자동 재생(isAutoStart=true)으로 설정되어 있으면 첫 번째 대사 재생
            if (isAutoStart) SetNextDialog();

            isFirst = false;
        }
        if (Managers.Input.leftClick)
        {
            // 텍스트 타이핑 효과를 재생중일때 마우스 왼쪽 클릭하면 타이핑 효과 종료
            if (isTypingEffect == true)
            {
                isTypingEffect = false;

                // 타이핑 효과를 중지하고, 현재 대사 전체를 출력한다
                StopCoroutine("OnTypingText");
                texts["DialogText"].text = dialogDatas[currentSpeakerIndex].dialog;
                // 대사가 완료되었을 때 출력되는 커서 활성화
                buttons["ArrowButton"].gameObject.SetActive(true);
            }
        }



        return false;
    }
    private void SetNextDialog()
    {
     
        BindDialog(currentSpeakerIndex, false);

        // 현재 화자 순번 설정
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
    public int speakerIndex;    // 이름과 대사를 출력할 현재 DialogSystem의 speakers 배열 순번
    public string name;         // 캐릭터 이름
    [TextArea(3, 5)]
    public string dialog;		// 대사
}
