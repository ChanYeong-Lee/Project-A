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

        //start¿¡¼­ ÇÏ¸é µÇ°í enable¿¡¼­ÇÏ¸é null¶ä.... ÇÏ....~~
        Debug.Log($"°×¸Þ : {GameEventsManager.Instance}");
        Debug.Log($"ÄùÀÌ : {GameEventsManager.Instance.questEvents}");
        Debug.Log($"Äù¾Æ :{questId}");
        Debug.Log($"ÄùÆú¾Æ : {questForPoint}");
        GameEventsManager.Instance.questEvents.onQuestStateChange += QuestStateChange;
        GameEventsManager.Instance.inputEvents.onSubmitPressed += SubmitPressed;
    }
    private void OnEnable()
    {
        
    }
    private void OnDisable()
    {
        GameEventsManager.Instance.questEvents.onQuestStateChange -= QuestStateChange;
        GameEventsManager.Instance.inputEvents.onSubmitPressed -= SubmitPressed;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            playerIsNear = true;
      
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
