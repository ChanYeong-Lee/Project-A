using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;

public class UIQuestSlot : MonoBehaviour, ISelectHandler
{
    private TextMeshProUGUI buttonText;

    private UnityAction onSelectAction;

    //instantiate�Ҷ� disalbed�� �����̿��� �ٽ� �������� initiate�������
    public void Initialized(string displayName, UnityAction selectAction)
    {
        this.buttonText = this.GetComponent<TextMeshProUGUI>();
        this.buttonText.text = displayName;
        this.onSelectAction = selectAction;
    }

    public void OnSelect(BaseEventData eventData)
    {
        onSelectAction();
    }

    private void OnEnable()
    {
   
    }

}