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
            // TODO : ������ �ν��Ͻ� ���� �� contents�� Add
            // ���� Ÿ�԰� ���� �ν��Ͻ� set active true
            // �� ���� �޴� set active false
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
