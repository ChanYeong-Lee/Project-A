using System;
using QuestState = Define.QuestState;



public class QuestEvents 
{
    public Action<string> onStartQuest;
    public void StartQuest(string id)
    {
        if (onStartQuest != null)
        {
            onStartQuest(id);
        }
    }

    public event Action<string> onAdvanceQuestStep;
    public void AdvanceQuestStep(string id)
    {
        if (onAdvanceQuestStep != null)
        {
            onAdvanceQuestStep(id);
        }
    }

    public event Action<string> onCompleteQuest;
    public void CompleteQuest(string id)
    {
        if (onCompleteQuest != null)
        {
            onCompleteQuest(id);
        }
    }

    public event Action<Quest> onQuestStateChange;
    public void QuestStateChange(Quest quest)
    {
        if (onQuestStateChange != null)
        {
            onQuestStateChange(quest);
        }
    }

    public event Action<string, int, QuestStepState> onQuestStepStateChange;
    public void QuestStepStateChange(string id, int stepIndex, QuestStepState questStepState)
    {
        if (onQuestStepStateChange != null)
        {
            onQuestStepStateChange(id, stepIndex, questStepState);
        }
    }
}
