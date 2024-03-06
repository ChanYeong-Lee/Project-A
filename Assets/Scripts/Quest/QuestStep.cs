using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class QuestStep : MonoBehaviour
{

    private bool isCompleted = false;
    private string questId;
    private int stepIndex;

    public void InitializedQuestStep(string questId, int stepIndex, string questStepState)
    {
        this.questId = questId;
        this.stepIndex = stepIndex;
        if (questStepState != null && questStepState != " ")
        {
            SetQuestStepState(questStepState);
        }
    }

    protected void CompleteQuestStep()
    {
        if (!isCompleted)
        {
            isCompleted = true;

            //Advance the quest forward now that we've finished this step
            GameEventsManager.Instance.questEvents.AdvanceQuestStep(questId);
            Destroy(this.gameObject);
        }
    }

    protected void ChangeState(string newState)
    {
        GameEventsManager.Instance.questEvents.QuestStepStateChange(questId, stepIndex, new QuestStepState(newState));
    }

    protected abstract void SetQuestStepState(string state);

}
