using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[CreateAssetMenu(fileName = "New Quest Info", menuName = "ScriptableObject/Quest Info", order = 1)]
public class QuestInfoSo : ScriptableObject
{
    [field: SerializeField] public string id { get; private set; }

    [Header("General")]
    public string questName;
    [TextArea(1, 3)] public string description;
    public bool isCompleted;

    [Header("Requirement")]
    public int requirementPlayerLevel;
    public QuestInfoSo[] questPrerequisites;

    [Header("Step")]
    public GameObject[] questStepPrefabs;

    [Header("Reward")]
    public int goldReward;
    public int expReward;

    //id는 항상 scirptableObject의 이름일 것
    private void OnValidate()
    {
       #if UNITY_EDITOR
        id = this.name;
        UnityEditor.EditorUtility.SetDirty(this);
        #endif
    }
}

