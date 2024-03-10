using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class BossTrigger : MonoBehaviour
{
    [SerializeField] private CinemachineVirtualCamera vCam;
    [SerializeField] private GameObject cart;
    private Monster boss;

    private void Awake()
    {
        boss = GetComponentInParent<Monster>(); 
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            StartCoroutine(CameraCoroutine());
            Destroy(GetComponent<BoxCollider>());
        }
    }

    private IEnumerator CameraCoroutine()
    {
        vCam.enabled = true;
        float count = 0.0f;
        while (true)
        {
            count += Time.deltaTime;
            vCam.GetCinemachineComponent<CinemachineTrackedDolly>().m_PathPosition = count;

            if (4.0f < count)
            {
                break;
            }

            yield return null;
        }
        
        Managers.Game.EnterBossMonsterStage(boss);

        Destroy(vCam.gameObject);
        Destroy(cart.gameObject);
        Destroy(gameObject);
    }
}
