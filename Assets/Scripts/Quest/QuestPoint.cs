using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using QuestState = Define.QuestState;

//[RequireComponent(typeof(CapsuleCollider))]
public class QuestPoint : MonoBehaviour
{
    [Header("Quest")]
    [SerializeField] private QuestInfoSo questForPoint;

    public bool playerIsNear = false;

    private string questId;

    private QuestState currentQuestState;

    [Header("Config")]
    public bool startPoint;
    public bool finishPoint;

    private void Start()
    {
        questId = questForPoint.id;


        GameEventsManager.Instance.questEvents.onQuestStateChange += QuestStateChange;
    }
    private void OnEnable()
    {

    }
    private void OnDisable()
    {
        GameEventsManager.Instance.questEvents.onQuestStateChange -= QuestStateChange;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            playerIsNear = true;
            SubmitPressed();


        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            playerIsNear = false;
        }
    }

    private void QuestStateChange(Quest quest)
    {
        //Only update the quest state if this point has the corresponding quest
        if (quest.questInfo.id.Equals(questId))
        {
            currentQuestState = quest.state;
            Debug.Log($"Quest with id : {questId}, Update to State : {currentQuestState} ");
        }
    }

    private void SubmitPressed()
    {
        if (false == playerIsNear)
        {
            return;
        }

        // start or finish a quest
        if (currentQuestState.Equals(QuestState.CanStart) && startPoint)
        {
            GameEventsManager.Instance.questEvents.StartQuest(questId);
        }
        else if (currentQuestState.Equals(QuestState.CanFinish) && finishPoint)
        {
            GameEventsManager.Instance.questEvents.CompleteQuest(questId);
        }
    }

}
