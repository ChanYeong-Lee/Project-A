using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private PlayerData playerData;
    [SerializeField] private LayerMask gatheringLayerMask; 
    [SerializeField] private Inventory inventory;
    [SerializeField] private GameObject scannerPrefab;
    
    private Collider[] detectedColliders;
    
    private float farmingTime = 0;
    private float durationTime = 10;
    private float scannerSize = 500;

    private void Awake()
    {
        detectedColliders = new Collider[1];
        playerData = Managers.Resource.Load<PlayerData>("ScriptableObject/Creature/Player Data");
    }

    private void Update()
    {
        // ��ȣ�ۿ�
        if (Input.GetKey(KeyCode.F))
        {
            Debug.Log("F �Է�");
            Farming();
        }

        if (Input.GetKeyUp(KeyCode.F))
        {
            farmingTime = 0;
        }

        // �κ� üũ
        if (Input.GetKeyDown(KeyCode.I))
        {
            Debug.Log("�κ� ������ üũ");
            foreach (KeyValuePair<ItemData, int> item in inventory.GetComponent<Inventory>().ItemDataDic)
            {
                Debug.Log($"{item.Key.ItemName} : {item.Value}");
            }
        }

        // ��ĳ��
        if (Input.GetKeyDown(KeyCode.G))
        {
            StartCoroutine(Scanning());
        }
    }

    private void Farming()
    {
        Vector3 center = transform.TransformPoint(new Vector3(0, 1, 1));
        int detectCount = Physics.OverlapSphereNonAlloc(center, 1, detectedColliders, gatheringLayerMask);
        
        for (int i = 0; i < detectCount; i++)
        {
            Collider other = detectedColliders[i];
            Dictionary<FarmingItemData, int> dataDic = other.GetComponent<IFarmable>().Farming(out var farmingType);
            // �ڽĿ�
            // Dictionary<FarmingItemData, int> dataDic = other.GetComponentInParent<IFarmable>().Farming(out var farmingType);

            if (dataDic == null)
                return;
            
            float farmingTime = playerData.FarmingTime;

            // �Ĺ� ���� �ִϸ��̼��̳� ��Ÿ ��� ����ġ ��
            switch (farmingType)
            {
                case Define.FarmingType.None:
                    break;
                case Define.FarmingType.Gathering:
                    break;
                case Define.FarmingType.Felling:
                    break;
                case Define.FarmingType.Mining:
                    break;
                case Define.FarmingType.Dismantling:
                    break;
                default:
                    throw new ArgumentOutOfRangeException();
            }

            Debug.Log($"{farmingType} : {other.name}");

            this.farmingTime += Time.deltaTime;
            if (farmingTime > this.farmingTime)
                return;
            
            foreach (var data in dataDic) 
                inventory.TryGainItem(data.Key, data.Value);

            other.GetComponentInParent<EnvSpawner>().Despawn(other.GetComponent<Environment>());
        }
    }

    private IEnumerator Scanning()
    {
        GameObject scanner = Managers.Pool.Pop(scannerPrefab, transform);
        ParticleSystem ps = scanner.transform.GetChild(0).GetComponent<ParticleSystem>();

        scanner.transform.position = transform.position;

        if (ps != null)
        {
            var main = ps.main;

            main.startLifetime = durationTime;
            main.startSize = scannerSize;
        }

        yield return new WaitForSeconds(durationTime + 1);
        Managers.Pool.Push(scanner);
    }
}
