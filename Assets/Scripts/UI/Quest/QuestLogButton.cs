using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using TMPro;
using UnityEngine.UI;
using static Define;

public class QuestLogButton : MonoBehaviour, ISelectHandler
{
    public Button button { get; private set; }
    private TextMeshProUGUI buttonText;
    private UnityAction onSelectAction;

    // because we're instantiating the button and it may be disabled when we
    // instantiate it, we need to manually initialize anything here.
    public void Initialize(string displayName, UnityAction selectAction)
    {
        this.button = this.GetComponent<Button>();
        this.buttonText = this.GetComponentInChildren<TextMeshProUGUI>();

        this.buttonText.text = displayName;
        this.onSelectAction = selectAction;
    }

    public void OnSelect(BaseEventData eventData)
    {
        onSelectAction();
    }

    public void SetState(QuestState state)
    {
        switch (state)
        {
            case QuestState.RequiredNotMet:
            case QuestState.CanStart:
                buttonText.color = Color.red;
                break;
            case QuestState.InProgress:
            case QuestState.CanFinish:
                buttonText.color = Color.yellow;
                break;
            case QuestState.Finished:
                buttonText.color = Color.green;
                break;
            default:
                Debug.LogWarning("Quest State not recognized by switch statement: " + state);
                break;
        }
    }
}