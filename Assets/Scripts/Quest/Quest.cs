using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using QuestState = Define.QuestState;

public class Quest
{
    public QuestInfoSo questInfo;
    public QuestState state;
    public int currentQuestStepIndex;

    private QuestStepState[] questStepStates;

    public Quest(QuestInfoSo questInfoSo)
    {
        this.questInfo = questInfoSo;
        this.state = QuestState.RequiredNotMet;
        this.currentQuestStepIndex = 0;
        this.questStepStates = new QuestStepState[questInfo.questStepPrefabs.Length];
        for (int i = 0; i < questStepStates.Length; i++)
        {
            this.questStepStates[i] = new QuestStepState();
        }
    }

    public Quest(QuestInfoSo questInfo, QuestState questState, int currentQuestStepIndex, QuestStepState[] questStepStates)
    {
        this.questInfo = questInfo;
        this.state = questState;
        this.currentQuestStepIndex = currentQuestStepIndex;
        this.questStepStates = questStepStates;

        // if the quest step states and prefabs are different lengths,
        // something has changed during development and the saved data is out of sync.
        if (this.questStepStates.Length != this.questInfo.questStepPrefabs.Length)
        {
            Debug.LogWarning("Quest Step Prefabs and Quest Step States are "
                + "of different lengths. This indicates something changed "
                + "with the QuestInfo and the saved data is now out of sync. "
                + "Reset your data - as this might cause issues. QuestId: " + this.questInfo.id);
        }
    }


    public void MoveToNextStep()
    {
        currentQuestStepIndex++;
    }

    public bool CurrentStepExists()
    {
        return currentQuestStepIndex < questInfo.questStepPrefabs.Length;
    }

    public void InstantiateCurrentQuestStep(Transform parentTransform)
    {
        GameObject questStepPrefab = GetCurrentQuestPrefab();
        if (questStepPrefab != null)
        {
            QuestStep questStep = Object.Instantiate<GameObject>(questStepPrefab, parentTransform).GetComponent<QuestStep>();
            questStep.InitializedQuestStep(questInfo.id, currentQuestStepIndex, questStepStates[currentQuestStepIndex].state);
        }
    }
    private GameObject GetCurrentQuestPrefab()
    {
        GameObject questStepPrefab = null;
        if (CurrentStepExists())
        {
            questStepPrefab = questInfo.questStepPrefabs[currentQuestStepIndex];
        }
        else
        {
            Debug.LogWarning("Tried to get quest step prefab, but stepIndex was out of range indicating that "
                + "there's no current step: QuestId=" + questInfo.id + ", stepIndex=" + currentQuestStepIndex);
        }
        return questStepPrefab;
    }

    public void StoreQuestStepState(QuestStepState questStepState, int stepIndex)
    {
        if (stepIndex < questStepStates.Length)
        {
            questStepStates[stepIndex].state = questStepState.state;

        }
        else
        {
            Debug.LogWarning("Tried to access quest step data, but stepIndex was out of range: "
                + "Quest Id = " + questInfo.id + ", Step Index = " + stepIndex);
        }
    }

    public QuestData GetQuestData()
    {
        return new QuestData(state, currentQuestStepIndex, questStepStates);
    }
    public string GetFullStatusText()
    {
        string fullStatus = "";

        if (state == QuestState.RequiredNotMet)
        {
            fullStatus = "Requirements are not yet met to start this quest.";
        }
        else if (state == QuestState.CanStart)
        {
            fullStatus = "This quest can be started!";
        }
        else
        {
            // display all previous quests with strikethroughs
            for (int i = 0; i < currentQuestStepIndex; i++)
            {
                fullStatus += "<s>" + questStepStates[i].state + "</s>\n";
            }
            // display the current step, if it exists
            if (CurrentStepExists())
            {
                fullStatus += questStepStates[currentQuestStepIndex].state;
            }
            // when the quest is completed or turned in
            if (state == QuestState.CanFinish)
            {
                fullStatus += "The quest is ready to be turned in.";
            }
            else if (state == QuestState.Finished)
            {
                fullStatus += "The quest has been completed!";
            }
        }

        return fullStatus;
    }
}
