MapScene 2
 - 
 - Terrains에 2, 4번 터레인에 있는 Collectible_Objects 안에 있는 오브젝트들만 상호작용 가능함
 - 1
 - g 키 누르면 스캐너 작동되면서 Env 레이어인 오브젝트들 아웃라인 생겼다가 스캐너가 꺼지면 아웃라인 사라짐
 - env 오브젝트들 안에 있는 빌보드에도 적용되서 멀리있는 오브젝트 아웃라인이 이상하게 보이는 것들이 있음
 - 플레이어가 생기면 테스트 후에 상호작용 방식 수정 필요
   - 현재 오버랩을 이용해서 콜라이더를 체크해서 상호작용하는 방식 -> 플레이어와 env간의 높낮이 차이가 크면 상호작용이 안될 때가 있음
   - 오버랩이 탐지하는 콜라이더의 크기를 키우거나 다른 방식으로 수정 해야함
   

 - 파밍할 수 있는 프리팹은 Layer : Env 로 바꾸기
 - 프리팹에 Environment.cs 추가 및 isFarming true로 설정
 - 해당 프리팹에 맞는 env data 추가 또는 새로 생성해서 참조하기


 - "Assets/ThirdParty/Fantasy Adventure Environment/Prefabs/Trees" 경로에 있는 나무 프리랩에 테스트용 Env Data 들어가있음


Monster 
 - 
 - 