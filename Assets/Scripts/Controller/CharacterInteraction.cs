using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterInteraction : MonoBehaviour
{
    [SerializeField] private LayerMask gatheringLayerMask; 
    [SerializeField] private GameObject scannerPrefab;
    
    private Inventory inventory;
    private Collider[] detectedColliders;
    
    private float farmingTime = 0;
    private float durationTime = 10;
    private float scannerSize = 500;
    private bool interaction;

    public bool Interaction => interaction;

    private void Awake()
    {
        detectedColliders = new Collider[1];
    }

    private void Start()
    {
        inventory = Managers.Game.Inventory;
    }

    private void Update()
    {
        if (Input.GetKey(KeyCode.F))
        {
            interaction = true;
            Farming();
        }

        if (Managers.Input.eKey)
        {
            interaction = true;
            Farming();
        }
        else
        {
            interaction = false;
        }

        if (Input.GetKeyUp(KeyCode.F))
        {
            interaction = false;
            farmingTime = 0;
        }

        if (Input.GetKeyDown(KeyCode.G))
        {
            StartCoroutine(Scanning());
        }
    }

    public void Farming()
    {
        Vector3 center = transform.TransformPoint(new Vector3(0, 1, 1));
        int detectCount = Physics.OverlapSphereNonAlloc(center, 1, detectedColliders, gatheringLayerMask);
        
        for (int i = 0; i < detectCount; i++)
        {
            Collider other = detectedColliders[i];
            
            // Dictionary<FarmingItemData, int> dataDic = other.GetComponent<IFarmable>().Farming(out var farmingType);
            // Dictionary<FarmingItemData, int> dataDic = other.GetComponentInParent<IFarmable>().Farming(out var farmingType);

            Dictionary<FarmingItemData, int> dataDic = new Dictionary<FarmingItemData, int>();

            dataDic = other.gameObject.layer == LayerMask.NameToLayer("Enemy")
                ? other.GetComponentInParent<IFarmable>().Farming(out var farmingType)
                : other.GetComponent<IFarmable>().Farming(out farmingType);
            
            if (dataDic == null)
                return;

            float farmingTime = GetComponent<Player>().Data.FarmingTime;

            // ??? ???? ?????????? ??? ??? ????? ??
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
            {
                inventory.TryGainItem(data.Key, data.Value);
            }

            if (farmingType == Define.FarmingType.Dismantling)
                other.GetComponentInParent<MonsterSpawner>().Despawn(other.GetComponentInParent<Monster>());
            else
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
