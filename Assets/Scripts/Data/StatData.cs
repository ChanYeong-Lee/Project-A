using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

[CreateAssetMenu(fileName = "New Stat Data", menuName = "ScriptableObject/Stat Data")]
    
public class StatData : ScriptableObject
{
    [Header("Stat Info")] 
    [SerializeField] private string creatureName;
    [SerializeField] private List<Stat> stats;

    public string CreatureName => creatureName;
    public List<Stat> Stats => stats;
}

[Serializable]
public class Stat
{
    [SerializeField] private int level;
    [SerializeField] private int healthPoint;
    [SerializeField] private float speed;
    [SerializeField] private float attack;
    [SerializeField] private float defence;

    public int Level { get => level; set => level = value; }
    public int HealthPoint { get => healthPoint; set => healthPoint = value; }
    public float Speed { get => speed; set => speed = value; }
    public float Attack { get => attack; set => attack = value; }
    public float Defence { get => defence; set => defence = value; }
}