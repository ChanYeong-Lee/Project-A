using System;
using UnityEngine;

public class Player : MonoBehaviour
{
    [SerializeField] private PlayerData data;
    private Stat currentStat;
    private int currentLevel;
    private int currentExp;

    public PlayerData Data => data;
    public int CurrentLevel => currentLevel;
    public int CurrentExp => currentExp;

    private void Start()
    {
        currentLevel = 1;
        currentStat = new Stat(data.Stats.Find(stat => stat.Level == currentLevel));
        currentExp = 0;
    }

    private void Update()
    {
        // TEST CODE
        if (Input.GetKeyDown(KeyCode.F5))
        {
            GainExp(7);
        }
        if (Input.GetKeyDown(KeyCode.F6))
        {
            GainExp(55);
        }
    }

    public void GainExp(int exp)
    {
        currentExp += exp;

        CheckLevel(currentExp);

        Debug.Log($"currentLevel : {currentLevel}, currentExp : {currentExp}");
    }

    private void CheckLevel(int exp)
    {
        if (exp >= data.ExpList[currentLevel - 1])
        {
            exp -= data.ExpList[currentLevel - 1];
            currentLevel++;
            CheckLevel(exp);
        }
        else
        {
            currentExp = exp;
            currentStat = new Stat(data.Stats.Find(stat => stat.Level == currentLevel));
        }
    }
}