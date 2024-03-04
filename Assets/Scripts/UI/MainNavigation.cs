using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainNavigation : MonoBehaviour
{
    [SerializeField] private List<NavigationSlot> slotPrefabs;
    [SerializeField] private List<NavigationData> dataList;

    [SerializeField] private List<NavigationSlot> slots;
    private List<NavigationSlot> activeSlots;
    private Dictionary<NavigationType, NavigationSlot> slotDictionary;

    private void Awake()
    {
        activeSlots = new List<NavigationSlot>();
        slotDictionary = new Dictionary<NavigationType, NavigationSlot>();
        
        foreach (NavigationSlot slot in slotPrefabs)
        {
            // TODO : 프리팹 생성해서 Dictionary에 추가
        }

        foreach (NavigationSlot slot in slots)
        {
            slotDictionary.Add(slot.Type, slot);
            slot.gameObject.SetActive(false);
        }
    }

    public void SelectMenu(MenuType menuType)
    {
        NavigationData data = dataList.Find((a) => a.Type == menuType);

        foreach (NavigationSlot slot in slots)
        {
            if (data.NavTypes.Contains(slot.Type))
            {
                if (activeSlots.Contains(slot))
                {
                    continue;
                }
                else
                {
                    slot.gameObject.SetActive(true);
                    activeSlots.Add(slot);
                }
            }
            else
            {
                if (activeSlots.Contains(slot))
                {
                    slot.gameObject.SetActive(false);
                    activeSlots.Remove(slot);
                }
            }
        }
    }
}
