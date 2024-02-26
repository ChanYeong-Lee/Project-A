using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public abstract class Creature : MonoBehaviour
{
    [SerializeField] protected CreatureData creatureData;
    [SerializeField] protected Vector3 spawnPos;
    [SerializeField] protected int currentLevel = 1;
    
    protected Stat currentStat;
    
    protected StateMachine stateMachine;
    
    public CreatureData CreatureData => creatureData;
    public Vector3 SpawnPos { get => spawnPos; set => spawnPos = value; }
    public int CurrentLevel { get => currentLevel; set => currentLevel = value; }
    public Stat CurrentStat { get => currentStat; set => currentStat = value; }

    private void Start()
    {
        Init();
    }

    public virtual void Init()
    {
        stateMachine = gameObject.GetOrAddComponent<StateMachine>();

        if (currentLevel < creatureData.Stats[0].Level || currentLevel > creatureData.Stats[^1].Level) 
            currentLevel = 1;
        
        currentStat = creatureData.Stats[currentLevel];
    }

    #region State

    protected abstract class CreatureState : BaseState
    {
        protected Creature owner;
        protected Vector3 spawnPos => owner.SpawnPos;
        
        public CreatureState(Creature owner)
        {
            this.owner = owner;
        }
    }

    #endregion
}

