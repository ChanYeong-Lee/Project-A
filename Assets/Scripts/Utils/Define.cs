using System;

public class Define
{
    // ���(const)
    // ������(Enum)
    // ����

    public const string RecipeDataPath = "ScriptableObject/Recipe/";
    
    public enum SceneType
    {
        LobbyScene,     // �κ� ��
        GameScene,      // ���� ��
    }
    
    // ������
    public enum ItemType
    {
        None,           //
        Equipment,      // ��� ������
        Consumption,    // �Ҹ� ������
        Etc
    }
    
    // ȭ�� �Ӽ�
    public enum AttributeType
    {
        None,           // �⺻
        Light,          // �� - �� ���� Ÿ�ݽ� ���� �ð����� ���� Ÿ�� ��ħ
        Bomb,           // ��ź - �ٸ�(�ϴܺ�) ���� Ÿ�ݽ� �̵� ����, ��(��ܺ�) ���� Ÿ�ݽ� ���� ����
        Goo,            // �������� - �ٸ�(�ϴܺ�) ���� Ÿ�ݽ� �̵��ӵ� ����, ��(��ܺ�) ���� Ÿ�ݽ� ���ݼӵ� ���� 
        Poison,         // �� - ��Ʈ ������, ������ ���� ���� ���� ����
        Fire,           // �� - ��Ʈ ������, ������ ���� ���� ���� ����
        Electric,       // ���� - ��� ���� ���� Ÿ�ݽ� �Ͻ� ����
        Etc
    }
    
    // �Ĺ� Ÿ��
    public enum FarmingType
    {
        None,           // �⺻
        Gathering,      // ä��
        Felling,        // ����
        Mining,         // ä��
        Dismantling     // ����(���� ä��)
    }
}