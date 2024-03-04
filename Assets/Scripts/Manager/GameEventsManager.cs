using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class GameEventsManager : MonoBehaviour
{
    public static GameEventsManager instance { get; private set; }

    public PlayerEvents playerEvents;
    public GoldEvents goldEvents;
    public MiscEvents miscEvents;
    public QuestEvents questEvents;

    private void Awake()
    {
        if (instance != null)
        {
            Debug.LogError("Found more than one Game Events Manager in the scene.");
        }
        instance = this;

        // initialize all events
        playerEvents = new PlayerEvents();
        goldEvents = new GoldEvents();
        miscEvents = new MiscEvents();
        questEvents = new QuestEvents();
    }


    //public QuestEvent questEvent;
    //public UnityEvent response;
    //public void OnQuestEventRaised(QuestData quest)
    //{
    //    // Handle the quest data
    //    HandleQuestEvent(quest);
    //}

    //private void HandleQuestEvent(QuestData quest)
    //{
    //    response.Invoke();
    //}

    //private void OnEnable()
    //{
    //    if (questEvent != null)
    //        questEvent.RegisterListener(this);
    //}

    //private void OnDisable()
    //{
    //    if (questEvent != null)
    //        questEvent.UnregisterListener(this);
    //}

}