using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[CreateAssetMenu(fileName = "New Quest Data", menuName = "ScriptableObject/Quest Data", order = 1)]
public class QuestData : ScriptableObject
{
    [field: SerializeField] public string id { get; private set; }

    [Header("General")]public string questName;
    [TextArea(1, 3)] public string description;
    public bool isCompleted;
    
    public int[] npcId;

    [Header("Requirement")]
    public int requirementPlayerLevel;
    public QuestData[] questPrerequisites;

    [Header("Step")]
    public GameObject[] questStepPrefab;

    [Header("Reward")]
    public int goldReward;
    public int expReward;

    public QuestData(string name, int[] npc)
    {
        questName = name;
        npcId = npc;
    }

    //id는 항상 scirptableObject의 이름일 것
    private void OnValidate()
    {
        #if UNITY_ENDITOR

        id = this.name;
        UnityEditor.EditorUtility.SetDirty(this);
        
        #endif
    }
}

