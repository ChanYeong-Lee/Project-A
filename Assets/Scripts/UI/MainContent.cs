using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainContent : MonoBehaviour
{
    [SerializeField] private List<ContentElement> contentsPrefabs;
    [SerializeField] private List<ContentElement> contents;
    private ContentElement currentElement;

    private void Awake()
    {
        foreach (ContentElement content in contentsPrefabs)
        {
            // TODO : 컨텐츠 인스턴스 생성 및 contents에 Add
            // 시작 타입과 같은 인스턴스 set active true
            // 그 외의 메뉴 set active false
        }
    }

    public void SelectMenu(MenuType menuType)
    {
        if (currentElement != null)
        {
            currentElement.gameObject.SetActive(false);
        }

        ContentElement newElement = contents.Find((a) => a.Type == menuType);
        newElement.gameObject.SetActive(true);
        currentElement = newElement;
    }
}
