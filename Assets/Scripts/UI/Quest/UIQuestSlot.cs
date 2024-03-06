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

    //instantiate할때 disalbed할 예정이여서 다시 수동으로 initiate해줘야함
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