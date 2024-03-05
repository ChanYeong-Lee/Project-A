using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "New Quest Event", menuName = "Quest Event")]
public class QuestEvent : ScriptableObject
{
    public QuestData questData;
    private List<GameEventsManager> listeners = new List<GameEventsManager>();

    public void Raise(QuestData quest)
    {
        // for (int i = listeners.Count - 1; i >= 0; i--)
        //     listeners[i].OnQuestEventRaised(quest);
        
    }
    public void RegisterListener(GameEventsManager listener)
    {
        listeners.Add(listener);
    }
    public void UnregisterListener(GameEventsManager listener)
    {
        listeners.Remove(listener);
    }


}
