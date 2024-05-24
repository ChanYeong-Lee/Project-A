using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class BossTrigger : MonoBehaviour
{
    private Monster boss;

    private void Awake()
    {
        boss = GetComponentInParent<Monster>(); 
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            Managers.Game.EnterBossMonsterStage(boss);
            Destroy(gameObject);
        }
    }
}
