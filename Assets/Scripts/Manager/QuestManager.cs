using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class QuestManager : MonoBehaviour
{
    public QuestData currentQuest;

    public int questActionIndex;
    public GameObject[] questObject;
    public List<QuestData> onGoingQuests;

    Dictionary<int, QuestData> questDictionary;

    private GameEventsManager listener;
    public QuestEvent onQuestStarted;
    public QuestEvent onQuestCompleted;

    void Start()
    {
        questDictionary = new Dictionary<int, QuestData>();
        onGoingQuests = new List<QuestData>();
        GenerataData();
    }

    void GenerataData()
    {
       
        questDictionary.Add(10, new QuestData("메인 퀘스트", new int[] { 1000, 2000 }));
        questDictionary.Add(20, new QuestData("증기를 찾아라", new int[] { 5000, 2000 }));
        questDictionary.Add(30, new QuestData("퀘스트 올 클리어", new int[] { 0 }));

        onQuestStarted.RegisterListener(listener);
        onQuestCompleted.RegisterListener(listener);
    }

    public void StartQuest(QuestData quest)
    {
        currentQuest = quest;
        onQuestStarted.Raise(quest);
        Debug.Log($"Quest started: {quest.questName}");
    }

    public void CompleteQuest()
    {
        if (currentQuest != null)
        {
            currentQuest.isCompleted = true;
            onQuestCompleted.Raise(currentQuest); // Raise the quest completed event
            Debug.Log($"Quest completed: {currentQuest.questName}");
            currentQuest = null;
        }
    }

    // Implement this method to handle the events
    public void OnQuestEventRaised()
    {
        // Perform actions based on the raised events
        // You can check which event was raised by examining the questData property
    }


}