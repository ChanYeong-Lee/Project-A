using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public abstract class Creature : MonoBehaviour
{
    [SerializeField] protected CreatureData creatureData;
    [SerializeField] protected int currentLevel;
    
    protected Stat currentStat;
    
    public CreatureData CreatureData => creatureData;
    public int CurrentLevel { get => currentLevel; set => currentLevel = value; }
    public Stat CurrentStat { get => currentStat; set => currentStat = value; }

    private void Start()
    {
        Init();
    }

    public virtual void Init()
    {
        if (currentLevel < creatureData.Stats[0].Level || currentLevel > creatureData.Stats[^1].Level) 
            currentLevel = 1;
        
        currentStat = creatureData.Stats[currentLevel];
    }
}