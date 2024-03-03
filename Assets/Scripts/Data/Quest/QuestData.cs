using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "New Quest Data", menuName = "ScriptableObject/Quest Data")]
public class QuestData : ScriptableObject
{
    public string questName;
    public string description;
    public bool isCompleted;
    // Add other quest-related properties here

    public int[] npcId;

    public QuestData(string name, int[] npc)
    {
        questName = name;
        npcId = npc;
    }
}
